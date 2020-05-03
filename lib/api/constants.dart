import 'package:http_auth/http_auth.dart' as http_auth;

const BACKEND_URL = '***REMOVED***';
const headers = {
  'Content-type' : 'application/json', 
  'Accept': 'application/json',
};

var client = http_auth.BasicAuthClient('***REMOVED***', '***REMOVED***');