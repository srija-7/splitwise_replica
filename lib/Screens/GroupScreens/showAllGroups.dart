import 'package:flutter/material.dart';


//  Group name style
const cardNameStyle = TextStyle(
  fontSize: 20.0,
);

// Group info style

const groupCardInfoStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.grey
);


class GroupCard extends StatelessWidget {
  const GroupCard({
    Key? key,
    this.groupIcon,
    required this.groupName,
    required this.groupInfo
  }) : super(key: key);
  final String? groupIcon;
  final String groupName;
  final String groupInfo;

  @override
  Widget build(BuildContext context) {

    String? groupIconPath = groupIcon == null ? "assets/groupicon.jpg" : groupIcon;
    var grpIcon = groupIcon != null ? Image(
      image: NetworkImage(groupIconPath!),
      height: 70.0,
    ) : Image(
      image: AssetImage(groupIconPath!),
      height: 70.0,
    );





    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),

            child: grpIcon
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: cardNameStyle,
                ),
                Text(
                  groupInfo,
                  style: groupCardInfoStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



class AllGroups extends StatefulWidget {
  const AllGroups({Key? key}) : super(key: key);

  @override
  _AllGroupsState createState() => _AllGroupsState();
}

class _AllGroupsState extends State<AllGroups> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        GroupCard(
          groupName: "Test1",
          groupInfo: "settled up",
        ),
        GroupCard(
          groupName: "Test2",
          groupInfo: "no expenses",
        ),
        GroupCard(
          groupName: "Test2",
          groupInfo: "settled up",
        ),
        // GroupCard(groupIcon: "https://opengraph.githubassets.com/082b5d5269351d0bc25a85ba322e7c9d2d2994cdc5625685cd15fce85c4e7bce/geekinglcq/C-mini-Compiler-using-flex-bison")
      ],
    );
  }
}
