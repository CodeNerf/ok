import 'dart:convert';
import 'package:amplify_core/amplify_core.dart';
import 'APIKey.dart';
import 'package:http/http.dart' as http;
import 'CivicModels.dart';

Future<List<Election>> getElection() async {
  final queryParams = {'key': googleAPIKey};
  final url =
      Uri.https("www.googleapis.com", "/civicinfo/v2/elections", queryParams);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final electionsJson = jsonResponse['elections'] as List<dynamic>?;
    final List<Election> elections = electionsJson != null
        ? electionsJson.map((election) => Election.fromJson(election)).toList()
        : <Election>[];
    print(elections);
    return elections;
  } else {
    safePrint(
        'Request failed with status: ${response.statusCode} ${response.reasonPhrase}.');
    return <Election>[];
  }
}

Future<List<PollingLocation>> getPollingLocation(String address) async {
  final queryParams = {
    'key': googleAPIKey,
    'address': address,
    'electionId':
        '2000', //TODO remove test election when we find a working address
  };
  final url =
      Uri.https("www.googleapis.com", "civicinfo/v2/voterinfo", queryParams);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final locationsJson = jsonResponse['pollingLocations'] as List<dynamic>?;
    final locations = locationsJson != null
        ? locationsJson
            .map((location) => PollingLocation.fromJson(location))
            .toList()
        : <PollingLocation>[];
    return locations;
  } else {
    safePrint(
        'Request failed with status:  ${response.statusCode} ${response.reasonPhrase}');
    return <PollingLocation>[];
  }
}
