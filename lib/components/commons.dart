import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textStyle({
  FontWeight fontWeight = FontWeight.w400,
  double fontSize = 15,
}) =>
    GoogleFonts.roboto(
      fontWeight: fontWeight,
      fontSize: fontSize,
    );

const buttonRadius = 30.0;

const fontSizeMain = 16.0;

const paddingMain = 20.0;

const borderColor = Color(0xFFE7E7EA);

const primaryColor = CupertinoColors.systemYellow;

const blackColor = Colors.black;

const dbName = 'game_scores.db';

const gamesTable = 'games';

const roundsTable = 'rounds';
