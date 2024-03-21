import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/src/widgets/framework.dart';

import 'main.dart';

import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    List<SizedBox> nums = [];
    for (int i = 0; i < 100; i++) {
      nums.add(SizedBox(width: 30, height: 50.0, child: Text('$i')));
    }
    ;

    return Scaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        body:
            /*    SizedBox.expand(
            child: Row(
              children: [
               /* SizedBox.expand(
                  child: ListWheelScrollView(
                    itemExtent: 42, 
                    children: nums),
                ),*/
                SizedBox.expand(
                  child: ListWheelScrollView(
                    itemExtent: 42, 
                    children: [
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.background,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.error,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.errorContainer,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.inversePrimary,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.inverseSurface,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onBackground,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onError,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onErrorContainer,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onInverseSurface,
                      ),Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onPrimary,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onPrimaryContainer,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onSecondary,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onSecondaryContainer,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onSurface,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onSurfaceVariant,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onTertiary,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.onTertiaryContainer,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.outline,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.outlineVariant,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.primary,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.primaryContainer,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.scrim,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.secondary,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.secondaryContainer,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.shadow,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.surface,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.surfaceTint,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.surfaceVariant,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.tertiary,
                      ),
                      Container(
                        width: 500.0,
                        height: 50.0,
                        color: color.tertiaryContainer,
                      ),
                          ]),
                ),
            ]),
          ))
    */
            SizedBox.expand(
                child: SizedBox.expand(
          child: ListWheelScrollView(itemExtent: 42, children: [
            Container(
              width: 500.0,
              height: 50.0,
              color: color.background,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.error,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.errorContainer,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.inversePrimary,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.inverseSurface,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onBackground,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onError,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onErrorContainer,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onInverseSurface,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onPrimary,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onPrimaryContainer,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onSecondary,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onSecondaryContainer,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onSurface,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onSurfaceVariant,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onTertiary,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.onTertiaryContainer,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.outline,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.outlineVariant,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.primary,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.primaryContainer,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.scrim,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.secondary,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.secondaryContainer,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.shadow,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.surface,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.surfaceTint,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.surfaceVariant,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.tertiary,
            ),
            Container(
              width: 500.0,
              height: 50.0,
              color: color.tertiaryContainer,
            ),
          ]),
        )));
  }
}
