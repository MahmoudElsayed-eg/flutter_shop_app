import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:flutter_shop_app/providers/products_list.dart';
import 'package:provider/provider.dart';

class AddEditUserProductScreen extends StatefulWidget {
  const AddEditUserProductScreen({Key? key}) : super(key: key);
  static const route = "/add-edit-user-product-screen";

  @override
  _AddEditUserProductScreenState createState() =>
      _AddEditUserProductScreenState();
}

class _AddEditUserProductScreenState extends State<AddEditUserProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imgFocus = FocusNode();
  final _imgController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _product =
      Product(id: "", title: '', description: "", imageUrl: "", price: 0);
  var _isInit = false;
  var _isLoading = false;

  @override
  void initState() {
    _imgFocus.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments as String?;
      if (args != null) {
        _product = Provider.of<ProductsList>(context, listen: false)
            .getProductById(args);
        _imgController.text = _product.imageUrl;
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void _updateImage() {
    if (!_imgFocus.hasFocus) {
      if ((!_imgController.text.contains("http") &&
              !_imgController.text.contains("https")) ||
          (!_imgController.text.endsWith(".png") &&
              !_imgController.text.endsWith('.jpg') &&
              !_imgController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_product.id.isNotEmpty) {
      await Provider.of<ProductsList>(context, listen: false)
          .updateProduct(_product);
    } else {
      try {
        await Provider.of<ProductsList>(context, listen: false)
            .addProduct(_product);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Error"),
                  content: Text("something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Product"),
          actions: [
            IconButton(onPressed: _submitForm, icon: Icon(Icons.save)),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _product.title,
                          decoration: InputDecoration(labelText: "Title"),
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if ((val != null && val.isEmpty) || val == null) {
                              return "please enter a title";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_priceFocus),
                          onSaved: (val) {
                            _product = Product(
                                isFavorite: _product.isFavorite,
                                id: _product.id,
                                title: val != null ? val : _product.title,
                                description: _product.description,
                                imageUrl: _product.imageUrl,
                                price: _product.price);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: _product.price == 0
                              ? ""
                              : _product.price.toString(),
                          decoration: InputDecoration(labelText: "Price"),
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          focusNode: _priceFocus,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_descriptionFocus),
                          validator: (val) {
                            if ((val != null && val.isEmpty) || val == null) {
                              return "please enter a price";
                            }
                            if (double.tryParse(val) == null) {
                              return "Please enter a valid number";
                            }
                            if (double.parse(val) <= 0) {
                              return "Please enter a value greater than zero!";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _product = Product(
                                id: _product.id,
                                title: _product.title,
                                description: _product.description,
                                imageUrl: _product.imageUrl,
                                isFavorite: _product.isFavorite,
                                price: val != null
                                    ? double.parse(val)
                                    : _product.price);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: _product.description,
                          focusNode: _descriptionFocus,
                          maxLines: 3,
                          decoration: InputDecoration(labelText: "Description"),
                          keyboardType: TextInputType.multiline,
                          validator: (val) {
                            if ((val != null && val.isEmpty) || val == null) {
                              return "please enter a description";
                            }
                            if (val.length < 10) {
                              return "please enter more than 10 characters";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _product = Product(
                                isFavorite: _product.isFavorite,
                                id: _product.id,
                                title: _product.title,
                                description:
                                    val != null ? val : _product.description,
                                imageUrl: _product.imageUrl,
                                price: _product.price);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: _imgController.text.isEmpty
                                  ? Center(child: Text("Enter image url"))
                                  : FittedBox(
                                      child: Image.network(
                                        _imgController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imgController,
                                focusNode: _imgFocus,
                                onFieldSubmitted: (_) => _submitForm(),
                                validator: (val) {
                                  if ((val != null && val.isEmpty) ||
                                      val == null) {
                                    return "please enter a url";
                                  }
                                  if (!val.startsWith("http") &&
                                      !val.startsWith("https")) {
                                    return "please enter a valid url";
                                  }
                                  if (!val.endsWith(".png") &&
                                      !val.endsWith('.jpg') &&
                                      !val.endsWith(".jpeg")) {
                                    return "please enter a valid image url";
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _product = Product(
                                      isFavorite: _product.isFavorite,
                                      id: _product.id,
                                      title: _product.title,
                                      description: _product.description,
                                      imageUrl:
                                          val != null ? val : _product.imageUrl,
                                      price: _product.price);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ));
  }

  @override
  void dispose() {
    _imgFocus.removeListener(_updateImage);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imgController.dispose();
    _imgFocus.dispose();
    super.dispose();
  }
}
