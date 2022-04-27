import 'package:flutter/material.dart';
import 'package:bil/constant/constants.dart';
import 'package:bil/model/posting.dart';
import 'package:bil/model/user.dart';
import 'package:bil/Service/DataBase.dart';

class PostingContainer extends StatefulWidget {
  final Posting posting;
  final Usermodel author;
  final String currentUserId;

  const PostingContainer(
      {required this.posting,
      required this.author,
      required this.currentUserId});
  @override
  _PostingContainerState createState() => _PostingContainerState();
}

class _PostingContainerState extends State<PostingContainer> {
  int _likesCount = 0;
  bool _isLiked = false;
  initPostingLikes() async {
    bool isLiked = await DatabaseServices.isLikePosting(
        widget.currentUserId, widget.posting);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likePosting() {
    if (_isLiked) {
      DatabaseServices.unlikePosting(widget.currentUserId, widget.posting);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likePosting(widget.currentUserId, widget.posting);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.posting.likes;
    initPostingLikes();
  }

  // @override
  // void initState() {
  // super.initState();
  // _likesCount = widget.posting.likes;
  // initPostingLikes();
  //}

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(-20.0, 10.0, 0.0),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.author.profilePicture.isEmpty
                    ? NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/6/6e/Breezeicons-actions-22-im-user.svg')
                    : NetworkImage(widget.author.profilePicture),
              ),
              SizedBox(width: 18),
              Text(
                widget.author.name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            widget.posting.text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          widget.posting.image.isEmpty
              ? SizedBox.shrink()
              : Container(
                  transform: Matrix4.translationValues(20.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        height: 225,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              scale: 1,
                              fit: BoxFit.fill,
                              image: NetworkImage(widget.posting.image),
                            )),
                      )
                    ],
                  ),
                ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? BIL_Color : Colors.black,
                    ),
                    onPressed: likePosting,
                  ),
                  Text(
                    _likesCount.toString() + ' Likes',
                  ),
                ],
              ),
              Text(
                widget.posting.timestamp.toDate().toString().substring(0, 19),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 10),
          Divider()
        ],
      ),
    );
  }
}
