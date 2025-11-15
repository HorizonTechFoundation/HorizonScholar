import 'package:get/get.dart';
import '../models/cgpa_model.dart';
import 'package:hive/hive.dart';

class CgpaController extends GetxController {
  var cgpaList = <CgpaModel>[].obs; // Holds the list of data (observable)

  late Box<CgpaModel> cgpaBox; // For Hive storage

  @override
  void onInit() {
    super.onInit();
    cgpaBox = Hive.box<CgpaModel>('cgpaBox'); // Open the Hive box
    loadCgpa();
  }

  void loadCgpa() {
    cgpaList.value = cgpaBox.values.toList();
  }

  void addCgpa(CgpaModel cgpa) {
    cgpaBox.add(cgpa);
    loadCgpa();
  }

  void updateCgpa(int index, CgpaModel newCgpa) {
    cgpaBox.putAt(index, newCgpa);
    loadCgpa();
  }

  void deleteCgpa(int index) {
    cgpaBox.deleteAt(index);
    loadCgpa();
  }
}
