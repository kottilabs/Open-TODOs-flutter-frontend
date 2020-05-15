import 'package:http/http.dart';
import 'package:logger/logger.dart';

final logger = Logger();
void logAndThrowUnsuccessfulResponse(Response response) {
  logger.e("Unsuccessful response: $response");
  throw response;
}