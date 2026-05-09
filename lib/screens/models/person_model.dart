class RegisteredPerson {
  final String name;
  final String id;
  final String registrationDate;
  final String status;
  final Map<String, bool> capturedFaces;

  RegisteredPerson({
    required this.name,
    required this.id,
    required this.registrationDate,
    required this.status,
    required this.capturedFaces,
  });
}

class PersonService {
  static final PersonService _instance = PersonService._internal();
  final List<RegisteredPerson> _registeredPersons = [];

  PersonService._internal();

  factory PersonService() {
    return _instance;
  }

  List<RegisteredPerson> getRegisteredPersons() {
    return _registeredPersons;
  }

  void addPerson(RegisteredPerson person) {
    _registeredPersons.add(person);
  }

  void clearAll() {
    _registeredPersons.clear();
  }
}
