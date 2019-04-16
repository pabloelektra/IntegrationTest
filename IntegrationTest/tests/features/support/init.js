'use strict';

const apickli = require('apickli');
const {Before, setDefaultTimeout} = require('cucumber');

Before(function() {
    this.apickli = new apickli.Apickli('http', '');
    this.apickli.addRequestHeader('Cache-Control', 'no-cache');
    this.apickli.setGlobalVariable('apigeeOrg', 'orgeTest');
    this.apickli.setGlobalVariable('apigeeDeveloper', 'ejemploDeveloper');
    this.apickli.setGlobalVariable('apigeeApp', 'ejemploApp');
    this.apickli.setGlobalVariable('apigeeUsername', 'user');
    this.apickli.setGlobalVariable('apigeePassword', 'pwd');
    this.apickli.setGlobalVariable('deploymentSuffix', 'v1');
    this.apickli.setGlobalVariable('apigeeHost', 'localhost:8000');
    this.apickli.setGlobalVariable('apigeeDomain', 'localhost:8000');
    this.apickli.setGlobalVariable('apigeeOauthEndpoint', 'oauth2/v1/token');
});

setDefaultTimeout(60 * 1000); // this is in ms