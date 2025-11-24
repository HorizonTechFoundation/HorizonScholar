import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

import '../controllers/document_controller.dart';
import '../models/document_model.dart';

class VaultScreen extends StatelessWidget {
  VaultScreen({super.key});

  final DocumentController controller = Get.put(DocumentController());

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFF8F4F4);
    final primary = const Color(0xFF146C94);
    final cardColor = const Color(0xFFBFE7FF);

    return Scaffold(
      backgroundColor: bgColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: bgColor,
      //   foregroundColor: Colors.black,
      //   title: Text(
      //     'Document Vault',
      //     style: GoogleFonts.righteous(
      //       fontSize: 22,
      //     ),
      //   ),
        // actions: [
        //   Obx(
        //     () => IconButton(
        //       tooltip: 'Show favourites only',
        //       icon: Icon(
        //         controller.showFavoritesOnly.value
        //             ? Icons.star
        //             : Icons.star_border,
        //       ),
        //       onPressed: controller.toggleFavoritesFilter,
        //     ),
        //   ),
        //   const SizedBox(width: 4),
        // ],
      // ),
      body: SafeArea(
        child:Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Document Vault",
                style: GoogleFonts.righteous(
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              _CategoryBar(
                controller: controller,
                primary: primary,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () {
                    final docs = controller.filteredDocuments;
                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          'No documents yet.\nTap + to add one.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        return _DocumentCard(
                          document: doc,
                          cardColor: cardColor,
                          primary: primary,
                          onOpen: () => _openDocument(doc),
                          onEdit: () => _showEditDocumentDialog(context, doc),
                          onToggleFav: () => controller.toggleFavorite(doc),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF146C94), // your blue color
        onPressed: () => _showAddDocumentDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),

    );
  }

  // ---------- helpers ----------

  Future<void> _openDocument(DocumentModel doc) async {
    await OpenFilex.open(doc.path);
  }

  Future<void> _showAddDocumentDialog(BuildContext context) async {
    final titleCtrl = TextEditingController();
    final selectedCategories = <String>[].obs;
    final isFav = false.obs;
    String? pickedPath;
    String? pickedType;

    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFFF6F1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- HEADER ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Document",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ---------- UPLOAD FILE ----------
                    Text(
                      "Select File",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    FilledButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                        );

                        if (result != null && result.files.single.path != null) {
                          pickedPath = result.files.single.path!;
                          pickedType = p
                              .extension(pickedPath!)
                              .replaceFirst('.', '')
                              .toLowerCase();

                          if (titleCtrl.text.trim().isEmpty) {
                            titleCtrl.text =
                                p.basenameWithoutExtension(pickedPath!);
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF146C94),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.upload_file),
                      label: Text(
                        pickedPath == null
                            ? "Choose file"
                            : p.basename(pickedPath!),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ---------- TITLE ----------
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: "Document Title",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ---------- CATEGORY ----------
                    Text(
                      "Categories",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: controller.categories
                          .where((c) =>
                              c != "All" &&
                              c != "Course" &&
                              c != "Fav") // remove reserved categories
                          .map(
                            (c) => ChoiceChip(
                              backgroundColor: const Color(0xFFE9E9E9),
                              selectedColor: const Color(0xFFAFD3E2),
                              label: Text(c),
                              selected: selectedCategories.contains(c),
                              onSelected: (val) {
                                if (val) {
                                  selectedCategories.add(c);
                                } else {
                                  selectedCategories.remove(c);
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),

                    // Add new category
                    TextButton.icon(
                      onPressed: () async {
                        final newCat =
                            await _showAddCategoryPrompt(context, controller);
                        if (newCat != null) selectedCategories.add(newCat);
                      },
                      icon: const Icon(Icons.add, color: Color(0xFF146C94)),
                      label: const Text(
                        "New",
                        style: TextStyle(color: Color(0xFF146C94)),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ---------- FAV SWITCH ----------
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isFav.value,
                      activeTrackColor: const Color(0xFF146C94),
                      activeColor: Colors.white,
                      title: Text(
                        "Mark as favourite",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      onChanged: (v) => isFav.value = v,
                    ),

                    const SizedBox(height: 14),

                    // ---------- BUTTONS ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Color(0xFF146C94)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF146C94),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (pickedPath == null ||
                                pickedType == null ||
                                titleCtrl.text.trim().isEmpty) return;

                            if (selectedCategories.isEmpty) {
                              selectedCategories.add("Important");
                            }

                            final doc = DocumentModel(
                              title: titleCtrl.text.trim(),
                              path: pickedPath!,
                              type: pickedType!,
                              isFav: isFav.value,
                              categories: selectedCategories.toList(),
                            );

                            await controller.addDocument(doc);
                            Navigator.of(ctx).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _confirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return Dialog(
              backgroundColor: const Color(0xFFF6F1F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------------ HEADER ------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Confirm Delete",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(false),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ------------ MESSAGE ------------
                    const Text(
                      "Are you sure you want to delete this document?",
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 18),

                    // ------------ ACTION BUTTONS ------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF146C94),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false; // <-- if dialog dismissed without choice
  }



  Future<void> _showEditDocumentDialog(
    BuildContext context,
    DocumentModel doc,
  ) async {
    final titleCtrl = TextEditingController(text: doc.title);
    final selectedCategories = doc.categories.toList().obs;
    final isFav = doc.isFav.obs;
    final isCourseDoc = doc.categories.contains('Course');

    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFFF6F1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- HEADER ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Document",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ---------- TITLE ----------
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: "Document title",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ---------- CATEGORIES ----------
                    Text(
                      "Categories",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: controller.categories
                          .where(
                            (c) =>
                                c != 'All' &&
                                c != 'Course' && // don't show Course chip
                                c != 'Fav', // Fav is a filter, not a doc category
                          )
                          .map(
                            (c) => ChoiceChip(
                              backgroundColor: const Color(0xFFE9E9E9),
                              selectedColor: const Color(0xFFAFD3E2),
                              label: Text(c),
                              selected: selectedCategories.contains(c),
                              onSelected: (val) {
                                if (val) {
                                  selectedCategories.add(c);
                                } else {
                                  selectedCategories.remove(c);
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),

                    // Add new category (still allowed)
                    TextButton.icon(
                      onPressed: () async {
                        final newCat =
                            await _showAddCategoryPrompt(context, controller);
                        if (newCat != null) {
                          selectedCategories.add(newCat);
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xFF146C94),
                      ),
                      label: const Text(
                        'New',
                        style: TextStyle(color: Color(0xFF146C94)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ---------- FAV SWITCH ----------
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Mark as favourite',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      value: isFav.value,
                      activeTrackColor: const Color(0xFF146C94),
                      activeColor: Colors.white,
                      onChanged: (v) => isFav.value = v,
                    ),

                    const SizedBox(height: 14),

                    // ---------- BUTTONS ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // DELETE button (left)
                        OutlinedButton.icon(
                          onPressed: isCourseDoc
                            ? null
                            : () async {
                                final confirmed = await _confirmDeleteDialog(context);
                                if (confirmed == true) {
                                  await controller.deleteDocument(doc);
                                  Navigator.of(context).pop(); // close edit dialog too
                                }
                              },

                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isCourseDoc
                                  ? Colors.grey.shade400
                                  : Colors.red,
                            ),
                            foregroundColor:
                                isCourseDoc ? Colors.grey.shade400 : Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text("Delete"),
                        ),

                        // Cancel + Save (right)
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Color(0xFF146C94)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF146C94),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                final newTitle = titleCtrl.text.trim();
                                if (newTitle.isEmpty) return;

                                doc.title = newTitle;
                                doc.isFav = isFav.value;
                                // keep any existing 'Course' tag even though chip hidden
                                doc.categories = selectedCategories.toList();

                                await controller.updateDocument(doc);
                                Navigator.of(ctx).pop();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<String?> _showAddCategoryPrompt(
    BuildContext context,
    DocumentController controller,
  ) async {
    final ctrl = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFFF6F1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Category",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    labelText: "Category name",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.label_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Color(0xFF146C94)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF146C94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final name = ctrl.text.trim();
                        if (name.isEmpty) return;

                        controller.addCategory(name);
                        Navigator.of(ctx).pop(name);
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.controller,
    required this.primary,
  });

  final DocumentController controller;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...controller.categories.map((cat) {
              final isSelected = controller.selectedCategory.value == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(
                    cat,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: primary,
                  backgroundColor: const Color(0xFFE5E5E5),
                  showCheckmark: false,
                  avatar: null,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  onSelected: (_) => controller.selectCategory(cat),
                ),
              );
            }).toList(),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () async {
                final screen = context.findAncestorWidgetOfExactType<VaultScreen>();
                if (screen is VaultScreen) {
                  await screen._showAddCategoryPrompt(context, controller);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.cardColor,
    required this.primary,
    required this.onOpen,
    required this.onEdit,
    required this.onToggleFav,
  });

  final DocumentModel document;
  final Color cardColor;
  final Color primary;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onToggleFav;

  bool get _isImage {
    final t = document.type.toLowerCase();
    return t == 'jpg' || t == 'jpeg' || t == 'png';
  }

  bool get _isPdf => document.type.toLowerCase() == 'pdf';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildPreview(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    document.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                onPressed: onEdit,
              ),
            ),
          ),
          // Positioned(
          //   top: 6,
          //   left: 6,
          //   child: GestureDetector(
          //     onTap: onToggleFav,
          //     child: Container(
          //       padding: const EdgeInsets.all(4),
          //       decoration: const BoxDecoration(
          //         color: Colors.white,
          //         shape: BoxShape.circle,
          //       ),
          //       child: Icon(
          //         document.isFav ? Icons.star : Icons.star_border,
          //         size: 18,
          //         color: document.isFav ? Colors.amber : Colors.grey[700],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    if (_isImage) {
      final file = File(document.path);
      return file.existsSync()
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox.expand(
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : const Center(child: Icon(Icons.broken_image, size: 40));
    } 
    
    // ---------- PDF PREVIEW WITH BG ----------
    else if (_isPdf) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F1F1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.picture_as_pdf,
            size: 50,
            color: Color(0xFF146C94),
          ),
        ),
      );
    }

    // ---------- OTHER FILE TYPES ----------
    else {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F1F1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.insert_drive_file,
            size: 40,
          ),
        ),
      );
    }
  }
}
