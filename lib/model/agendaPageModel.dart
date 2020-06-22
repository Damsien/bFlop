import 'package:http/http.dart' as http;

class AgendaPageModel {

  AgendaPageModel() {

  }

  Future<http.Response> fetchTest() {
    return http.get('https://flopedt.iut-blagnac.fr/ics/INFO/group/INFO1/4B.ics',
        headers: {'Content-Type': 'text/calendar'}
    );
  }

}