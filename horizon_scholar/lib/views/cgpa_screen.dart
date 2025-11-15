import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cgpa_controller.dart';
import '../models/cgpa_model.dart';

class CGPAScreen extends StatelessWidget {
  final CgpaController cgpaController = Get.put(CgpaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CGPA List')),
      body: Obx(() {
        return ListView.builder(
          itemCount: cgpaController.cgpaList.length,
          itemBuilder: (context, index) {
            final cgpa = cgpaController.cgpaList[index];
            return Card(
              child: ListTile(
                title: Text('Current Semester: ${cgpa.currentSem}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CGPA: ${cgpa.cgpa.toStringAsFixed(2)}'),
                    Text('Marks (first semester, sample): ${cgpa.marks.isNotEmpty ? cgpa.marks[0].join(", ") : "No marks"}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditCGPADialog(context, index, cgpaController, cgpa);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCGPADialog(context, cgpaController);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddCGPADialog(BuildContext context, CgpaController controller) {
    final currentSemController = TextEditingController();
    final cgpaValueController = TextEditingController();
    final marksController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add CGPA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: currentSemController, decoration: InputDecoration(labelText: 'Current Semester')),
            TextField(controller: cgpaValueController, decoration: InputDecoration(labelText: 'CGPA'), keyboardType: TextInputType.number),
            TextField(controller: marksController, decoration: InputDecoration(labelText: 'Marks (comma-separated, single semester)')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () { Get.back(); },
              child: Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final currentSem = int.tryParse(currentSemController.text) ?? 1;
                final cgpaValue = double.tryParse(cgpaValueController.text) ?? 0.0;
                // For now, only inputting one semester's marks
                List<double> marksList = marksController.text
                    .split(',')
                    .map((e) => double.tryParse(e.trim()) ?? 0.0)
                    .toList();
                List<List<double>> allMarks = [marksList];

                controller.addCgpa(CgpaModel(cgpa: cgpaValue, currentSem: currentSem, marks: allMarks));
                Get.back();
              },
              child: Text('Add'))
        ],
      ),
    );
  }

  void _showEditCGPADialog(BuildContext context, int index, CgpaController controller, CgpaModel oldCgpa) {
    final currentSemController = TextEditingController(text: oldCgpa.currentSem.toString());
    final cgpaValueController = TextEditingController(text: oldCgpa.cgpa.toString());
    final marksController = TextEditingController(
      text: oldCgpa.marks.isNotEmpty ? oldCgpa.marks[0].join(", ") : "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit CGPA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: currentSemController, decoration: InputDecoration(labelText: 'Current Semester')),
            TextField(controller: cgpaValueController, decoration: InputDecoration(labelText: 'CGPA'), keyboardType: TextInputType.number),
            TextField(controller: marksController, decoration: InputDecoration(labelText: 'Marks (comma-separated, single semester)')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () { Get.back(); },
              child: Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final currentSem = int.tryParse(currentSemController.text) ?? oldCgpa.currentSem;
                final cgpaValue = double.tryParse(cgpaValueController.text) ?? oldCgpa.cgpa;
                List<double> marksList = marksController.text
                    .split(',')
                    .map((e) => double.tryParse(e.trim()) ?? 0.0)
                    .toList();
                List<List<double>> allMarks = [marksList];

                controller.updateCgpa(index, CgpaModel(cgpa: cgpaValue, currentSem: currentSem, marks: allMarks));
                Get.back();
              },
              child: Text('Save'))
        ],
      ),
    );
  }
}
