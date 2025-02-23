import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpapers/states/collections/collections_bloc.dart';
import 'package:flutter_wallpapers/states/collections/collections_event.dart';
import 'package:flutter_wallpapers/states/collections/collections_state.dart';
import '../../data/network/response/collection_item_res.dart';
import '../../data/network/response/photo_res.dart';
import '../../routes/routes.dart';
import '../widgets/photo_item.dart';

class DetailCollection extends StatefulWidget {
  const DetailCollection({Key? key, required this.collectionItem})
      : super(key: key);

  final Collection collectionItem;

  @override
  State<StatefulWidget> createState() => _DetailCollectionState();
}

class _DetailCollectionState extends State<DetailCollection> {
  CollectionsBloc get collectionBloc => context.read<CollectionsBloc>();

  @override
  void initState() {
    collectionBloc.add(ResetData());
    collectionBloc.add(GetCollectionPhotos(widget.collectionItem.id ?? ""));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _collectionContent(widget.collectionItem),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.collectionItem.title ?? "",
        style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.0),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black87,
        ),
        onPressed: () {
          collectionBloc.add(ResetData());
          AppNavigator.pop();
        },
      ),
    );
  }

  Widget _collectionContent(Collection collectionItem) {
    return Center(
      child: BlocSelector<CollectionsBloc, CollectionsState, List<Photo>>(
          selector: (state) => state.listCollectionPhotos,
          builder: (_, listPhoto) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Text(
                        "${collectionItem.totalPhotos} Photos • Collected by ${collectionItem.user?.name}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]),
                ),
                SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 4,
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  // controller: widget.scrollController,
                  itemCount: listPhoto.length,
                  itemBuilder: (context, index) {
                    Photo item = listPhoto[index];
                    List<Photo> listPhotoSug = listPhoto;
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 50),
                      duration: Duration(milliseconds: (index * 50) + 500),
                      child: photoItem(context, item, listPhotoSug),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(2, index.isEven ? 4 : 2),
                )
              ],
            );
          }),
    );
  }
}
