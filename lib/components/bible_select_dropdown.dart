import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_holy_bible/controllers/bible_select_controller.dart';

class BibleSelectDropDown extends StatelessWidget {
  const BibleSelectDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BibleSelectController controller =
        Get.put<BibleSelectController>(BibleSelectController());

    var books = ['NIV', 'KJV', 'NKJV', 'AMP', 'MSG'];

    generateDropDownItems() {
      List<DropdownMenuItem<String>> dropDownMenuItems = [];
      for (var element in books) {
        dropDownMenuItems.add(
          DropdownMenuItem(
            child: Text(
              element,
              style: GoogleFonts.montserrat(   fontSize: 14,),
            ),
            value: element.toLowerCase(),
          ),
        );
      }
      return dropDownMenuItems;
    }

    return GetX<BibleSelectController>(
        builder: (controller) => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                elevation: 8,
                hint: Text(
                  (controller.selectedBible.value).toUpperCase(),
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.white),
                ),
                items: generateDropDownItems(),
                onChanged: (value) {
                  controller.setSelectedBible(value);
                })));
  }
}
