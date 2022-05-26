try {
	var fs = require('fs');
	var path = require('path');
	var rokuDeploy = require('roku-deploy');

	let argMap = {};

	for (const arg of process.argv) {
		const pair = arg.split('=');

		if (pair.length === 2 && pair[0].startsWith('--')) {
			if (pair[1].startsWith('[')) {
				pair[1] = pair[1].slice(pair[1].indexOf('[') + 1, pair[1].lastIndexOf(']')).split(',')
			}
			[, argMap[pair[0].slice(2)]] = pair;
		}
	}

	let config = {}
	let configFile = 'rokudeploy.json'

	try {
		let json = fs.readFileSync(configFile, { encoding: 'utf8' });
		Object.assign(config, JSON.parse(json));
	}
	catch (err) {
		if (err.code === 'ENOENT') {
			console.warn('WARNING: Config file "' + configFile + '" not found');
		} else {
			console.warn('ERROR: Could not parse "' + configFile + '":', err);
		}
	}

	Object.assign(config, argMap);

	if (
		!config.hostIp ||
		!config.password ||
		!config.files
	) {
		console.error(
			'ERROR: Failed to complete due to missing roku deploy values (hostIp, password and/or files)'
		);

		return -1;
	}

	config.host = config.hostIp
	delete config.hostIp

	let manifestBuildType = null

	if (argMap.build_type) {
		// We use only the first part of the name before dash, e.g., `debug_analytics-Name` becomes `debug_analytics` in manifest file
		manifestBuildType = argMap.build_type.split('-')[0]
	}
	else {
		let manifestData = fs.readFileSync('./manifest', 'utf8');
		if (manifestData) {
			foundBuildType = manifestData.match(/\nbuild_type=([^\r\n]+)/)
			if (foundBuildType && foundBuildType[1]) {
				manifestBuildType = foundBuildType[1]
				console.warn('WARNING: No --build_type param was specified, using value from manifest: ' + manifestBuildType);
			}
		}
		if (!manifestBuildType) {
			manifestBuildType = 'debug'
			console.warn('WARNING: No --build_type param was specified, falling back to: ' + manifestBuildType);
		}
	}

	if (manifestBuildType) {
		config.files.push({
			src: 'build_overrides/' + manifestBuildType + '/**'
		})

		if (argMap.build_type && manifestBuildType !== argMap.build_type) {
			config.files.push({
				src: 'build_overrides/' + argMap.build_type + '/**'
			})
		}
	}

	rokuDeploy.deploy(config, function (info) {
		if (!argMap.build_type || !manifestBuildType) {
			return;
		}

		let manifestFilePath = path.join(info.stagingFolderPath, 'manifest')
		let manifestData = fs.readFileSync(manifestFilePath, 'utf8');

		fs.writeFileSync(manifestFilePath, manifestData.replace(/\nbuild_type=[^\r\n]+/, 'build_type=' + manifestBuildType));
	})
	.then(function () {
		console.log("~~SUCCESSFUL DEPLOY~~");
		setTimeout( function() {}, 2000 );
	}, function (error) {
		console.error(error);
		setTimeout( function() { process.exit(1) }, 5000 );
	});
}
catch (err) {
	console.error(err);
	setTimeout( function () { process.exit(1) }, 5000 );
}
