import 'package:dio/dio.dart';
import 'package:example_project/data/network/models/response/dto_characters_response.dart';

class NetworkService {
  late final Dio _dio;

  NetworkService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://rickandmortyapi.com/api/',
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<DTOCharactersResponse> getAllCharacters(int page) async {
    final response = await _dio.get('character/?page=$page');
    return DTOCharactersResponse.fromJson(response.data);
  }
}
