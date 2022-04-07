
import 'package:flutter/material.dart';

class CityItem extends StatelessWidget {

  final String city;
  final GestureTapCallback? onItemClick;
  final VoidCallback? onDelClick;
  const CityItem({Key? key, this.onItemClick, this.onDelClick, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: InkWell(
          onTap: onItemClick,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.location_city, color: Colors.white),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(city, style: const TextStyle(color: Colors.white, fontSize: 20))
                      )
                  ),
                  IconButton(onPressed: onDelClick, icon: const Icon(Icons.delete, color: Colors.white, size: 20))
                ],
              ),
              const Divider(color: Colors.white, height: 1)
            ],
          ),
        )
    );
  }
}
