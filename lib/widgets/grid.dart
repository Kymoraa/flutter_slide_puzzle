import 'package:flutter/material.dart';
import 'package:sliding_puzzle/widgets/grid_button.dart';


class Grid extends StatelessWidget {
  var numbers = [];
  var size;
  Function clickGrid;
  Grid(this.numbers, this.size, this.clickGrid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = size.height;
    return SizedBox(
      height: height * 0.60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return numbers[index] != 0
                ? GridButton("${numbers[index]}", () {
                    clickGrid(index);
                  })
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
