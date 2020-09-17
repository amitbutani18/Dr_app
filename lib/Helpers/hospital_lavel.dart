import 'package:flutter/material.dart';

class HospitalLavel {
  const HospitalLavel(this.name, this.icon);
  final String name;
  final Icon icon;
}

class HospitalLavelProvider with ChangeNotifier {
  List<HospitalLavel> _list = <HospitalLavel>[
    const HospitalLavel(
        'Multi Specialist',
        Icon(
          Icons.multiline_chart,
          color: const Color(0xFF167F67),
        )),
    const HospitalLavel(
        'Verbal Level',
        Icon(
          Icons.local_hospital,
          color: const Color(0xFF167F67),
        )),
    const HospitalLavel(
        'Local Level',
        Icon(
          Icons.ac_unit,
          color: const Color(0xFF167F67),
        )),
  ];
  List<HospitalLavel> get items {
    return [..._list];
  }
}
