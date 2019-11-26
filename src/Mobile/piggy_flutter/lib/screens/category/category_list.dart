import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggy_flutter/blocs/categories/categories.dart';
import 'package:piggy_flutter/screens/category/category_form.dart';
import 'package:piggy_flutter/widgets/common/common_drawer.dart';
import 'package:piggy_flutter/widgets/common/message_placeholder.dart';
import 'package:piggy_flutter/utils/common.dart';

class CategoryListPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
// TODO: show recent number of transactions against categories
    // Stream<List<CategoryListItem>> categoriesWithTransactionCount = Observable
    //     .combineLatest2(
    //         categoryBloc.categories, homeBloc.recentTransactionsState,
    //         (List<Category> categories,
    //             RecentTransactionsState recentTransactionsState) {
    //   return categories
    //       .map<CategoryListItem>((category) => CategoryListItem(
    //           category: category,
    //           noOfTransactions:
    //               recentTransactionsState is RecentTransactionsPopulated
    //                   ? recentTransactionsState.result.transactions
    //                       .where((transaction) =>
    //                           transaction.categoryName == category.name)
    //                       .length
    //                   : 0))
    //       .toList();
    // }).asBroadcastStream();

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Categories'),
      ),
      body: _categoryListBuilder(),
      drawer: CommonDrawer(),
      floatingActionButton: FloatingActionButton(
          key: ValueKey<Color>(Theme.of(context).buttonColor),
          tooltip: 'Add new category',
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.add, color: Theme.of(context).primaryColor),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute<DismissDialogAction>(
                  builder: (BuildContext context) => CategoryFormPage(
                    title: "Add Category",
                  ),
                  fullscreenDialog: true,
                ));
          }),
    );
  }

  Widget _categoryListBuilder() =>
      BlocBuilder<CategoriesBloc, CategoriesState>(builder: (context, state) {
        if (state is CategoriesLoaded) {
          final categories = state.categories;
          if (categories.length > 0) {
            Iterable<Widget> categoryTiles = categories.map((category) {
              return MergeSemantics(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(category.name.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(category.name),
                  // subtitle: category.noOfTransactions > 0
                  //     ? Text(
                  //         '${category.noOfTransactions} transactions recently')
                  //     : null,
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute<DismissDialogAction>(
                            builder: (BuildContext context) => CategoryFormPage(
                              category: category,
                              title: 'Edit Category',
                            ),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                ),
              );
            });
            return ListView(children: categoryTiles.toList());
          } else {
            return MessagePlaceholder();
          }
        }
        return Center(child: CircularProgressIndicator());
      });
}
