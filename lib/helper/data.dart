import 'package:TimesWall/models/CategoryModel.dart';

List<CategoryModel> getCategory() {
  List<CategoryModel> category = List<CategoryModel>();

  //1
  category.add(CategoryModel(
      categoryName: 'General', imgPath: 'assets/color-circle.png'));

  //2
  category.add(
      CategoryModel(categoryName: 'Business', imgPath: 'assets/Business.png'));

  //3
  category.add(
      CategoryModel(categoryName: 'Technology', imgPath: 'assets/devices.png'));

  //4
  category.add(CategoryModel(
      categoryName: 'Entertainment', imgPath: 'assets/video-camera.png'));

  //5
  category
      .add(CategoryModel(categoryName: 'Science', imgPath: 'assets/atom.png'));

  //6
  category.add(
      CategoryModel(categoryName: 'Health', imgPath: 'assets/hospital.png'));
  return category;
}
