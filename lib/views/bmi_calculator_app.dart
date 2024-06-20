import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/agecubit/age_cubit.dart';
import 'package:flutter_application_2/blocs/bmi_calculate_cubit/calculate_bmi_cubit.dart';
import 'package:flutter_application_2/blocs/heightcubit/height_cubit.dart';
import 'package:flutter_application_2/views/constans.dart';
import 'package:flutter_application_2/views/ui/bmi_button.dart';
import 'package:flutter_application_2/views/ui/cards.dart';
import 'package:flutter_application_2/views/ui/header.dart';
import 'package:flutter_application_2/views/ui/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BmiCalculatorApp extends StatefulWidget {
  const BmiCalculatorApp({super.key});

  @override
  State<StatefulWidget> createState() => BmiCalculatorAppState();
}

enum Gender { male, female }

class BmiCalculatorAppState extends State<BmiCalculatorApp> {
  TextEditingController weightController = TextEditingController();
  Gender? gender;
  double height = 40;
  int heigh = 40;
  int age = 10;
  int weight = 40;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider(create: (BuildContext context) => HeightCubit()),
        BlocProvider(create: (BuildContext context) => AgeCubit()),
        BlocProvider(create: (BuildContext context) => CalculateBmiCubit()),
      ],
      child: BlocListener<CalculateBmiCubit, CalculateBmiState>(
        listener: (context, state) {
          if (state is CalculateBmiChangedState) {
            ScaffoldMessenger.of(context).showSnackBar(showSnackBar(context,
                state.bmi.toStringAsFixed(1), state.status, state.comment));
          } else if (state is BmiErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(context));
          }
        },
        child: Scaffold(
          backgroundColor: bgk,
          body: SafeArea(
            child: Column(
              children: [
                const Header(),
                const Text('123'),
                Expanded(
                  child: Row(
                    children:[
                      Expanded(
                        child: Cards(
                          color: gender == Gender.male
                              ? activeCardColor
                              : inactiveCardColor,
                          callback: () {
                            setState(
                              () {
                                gender = Gender.male;
                              },
                            );
                          },
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.mars, size: 90),
                              SizedBox(height: 5),
                              Text(
                                'MALE',
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Cards(
                          color: gender == Gender.female
                              ? activeCardColor
                              : inactiveCardColor,
                          callback: () {
                            setState(() {
                              gender = Gender.female;
                            });
                          },
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.venus, size: 90),
                              SizedBox(height: 5),
                              Text(
                                'FEMALE',
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Cards(
                  callback: () {},
                  child: Row(
                    children: [
                     Expanded(
                       child: Cards(
                         callback: () {},
                         child: BlocBuilder<HeightCubit, HeightState>(
                           builder: (context, state) {
                             return Column(
                               children: [
                                 const SizedBox(height: 3),
                                 const Text('HEIGHT', style: bodyTextStyle),
                                 Text(state.height.toString(),
                                     style: numberTextStyle),
                                 Slider(
                                   min: 40,
                                   max: 220,
                                   activeColor: bottomContainerColor,
                                   value: height,
                                   onChanged: (value) {
                                     height = value;
                                     context
                                         .read<HeightCubit>()
                                         .onHeightChanged(height.toInt());
                                     heigh = height.toInt();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                   ),
                  ),
                ),
                Expanded(
                  child: Row(
                  children: [
                    Expanded(
                      child: Cards(
                        callback: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'WEIGHT',
                              style: bodyTextStyle,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: 180,
                              height: 130,
                              decoration: decorationBox(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.026,
                                  ),
                                  TextFormField(
                                    controller: weightController,
                                    maxLength: 3,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                      } else {
                                        int value =
                                            int.parse(weightController.text);
                                        weight = value;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          196, 204, 199, 199),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                    Expanded(
                      child: Cards(
                        callback: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'AGE',
                              style: bodyTextStyle,
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              width: 180,
                              height: 130,
                              decoration: decorationBox(context),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.grey,
                                        child:
                                            ageContainer(context, Icons.remove),
                                        onTap: () {
                                          context
                                              .read<AgeCubit>()
                                              .ageDecrement();
                                        },
                                      ),
                                      BlocBuilder<AgeCubit, AgeState>(
                                        builder: (context, state) {
                                          age = state.age;
                                          return appText(
                                              context,
                                              state.age.toString(),
                                              30,
                                              Colors.white);
                                        },
                                      ),
                                      InkWell(
                                        splashColor: Colors.grey,
                                        child: ageContainer(context, Icons.add),
                                        onTap: () {
                                          context
                                            .read<AgeCubit>()
                                            .ageIncrement();
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                   ],
                  ),
                ),
                const SizedBox(height: 3),
                BmiButton(age: age, heigh: heigh, weight: weight),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


