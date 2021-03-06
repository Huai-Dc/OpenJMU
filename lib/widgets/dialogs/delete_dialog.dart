import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:openjmu/constants/constants.dart';
import 'package:openjmu/widgets/dialogs/loading_dialog.dart';

class DeleteDialog extends Dialog {
  final Post post;
  final Comment comment;
  final String whatToDelete;
  final String fromPage;
  final int index;

  DeleteDialog(this.whatToDelete, {this.post, this.comment, this.fromPage, this.index, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      title: Text("删除$whatToDelete"),
      content: Text(
        "是否确认删除这条$whatToDelete？",
        style: Theme.of(context).textTheme.body1.copyWith(
              fontSize: suSetSp(20.0),
            ),
      ),
      actions: <Widget>[
        PlatformButton(
          android: (BuildContext context) => MaterialRaisedButtonData(
            color: Theme.of(context).dialogBackgroundColor,
            elevation: 0,
            disabledElevation: 0.0,
            highlightElevation: 0.0,
            child: Text(
              '确认',
              style: TextStyle(
                color: currentThemeColor,
              ),
            ),
          ),
          ios: (BuildContext context) => CupertinoButtonData(
            child: Text(
              '确认',
              style: TextStyle(
                color: currentThemeColor,
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (this.comment != null) {
              Navigator.of(context).pop();
            }
            final _loadingDialogController = LoadingDialogController();
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) => LoadingDialog(
                text: "正在删除$whatToDelete",
                controller: _loadingDialogController,
                isGlobal: false,
              ),
            );
            if (this.comment != null) {
              debugPrint("Post ID: ${this.comment.post.id}");
              debugPrint("Comment ID: ${this.comment.id}");
              CommentAPI.deleteComment(this.comment.post.id, this.comment.id).then((response) {
                _loadingDialogController.changeState(
                  "success",
                  "$whatToDelete删除成功",
                );
                Instances.eventBus.fire(PostCommentDeletedEvent(this.comment.post.id));
              }).catchError((e) {
                debugPrint(e.toString());
                _loadingDialogController.changeState(
                  "failed",
                  "$whatToDelete删除失败",
                );
              });
            } else if (this.post != null) {
              PostAPI.deletePost(this.post.id).then((response) {
                _loadingDialogController.changeState(
                  "success",
                  "$whatToDelete删除成功",
                );
                Instances.eventBus.fire(PostDeletedEvent(
                  this.post.id,
                  this.fromPage,
                  this.index,
                ));
              }).catchError((e) {
                debugPrint(e.toString());
                debugPrint(e.response?.toString());
                _loadingDialogController.changeState(
                  "failed",
                  "$whatToDelete删除失败",
                );
              });
            }
          },
        ),
        PlatformButton(
          android: (BuildContext context) => MaterialRaisedButtonData(
            color: currentThemeColor,
            elevation: 0,
            disabledElevation: 0.0,
            highlightElevation: 0.0,
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ios: (BuildContext context) => CupertinoButtonData(
            child: Text(
              '取消',
              style: TextStyle(
                color: currentThemeColor,
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
