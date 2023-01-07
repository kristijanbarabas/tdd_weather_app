import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:weather_app_clean_architecture/core/network/network_info.dart';
import 'package:weather_app_clean_architecture/mocks/mock_all.mocks.dart';

void main() {
  NetworkInfoImpl? networkInfoImpl;
  MockDataConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      //arrange
      when(mockDataConnectionChecker!.hasConnection)
          .thenAnswer((_) async => true);
      //act
      final result = await networkInfoImpl!.isConnected;
      //assert
      verify(mockDataConnectionChecker!.hasConnection);
      expect(result, true);
    });
  });
}
