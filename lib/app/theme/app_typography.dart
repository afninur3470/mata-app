import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Heading Styles (Inter, weight 600-800)
  static final TextStyle headingH1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  static final TextStyle headingH2 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static final TextStyle headingH3 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static final TextStyle headingH4 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final TextStyle headingH5 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final TextStyle headingH6 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // Body Styles (Roboto, weight 400-500)
  static final TextStyle bodyLarge = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodySmall = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyLargeMedium = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static final TextStyle bodyMediumMedium = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static final TextStyle bodySmallMedium = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // Monospace Styles (JetBrains Mono)
  static final TextStyle codeLarge = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final TextStyle codeMedium = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final TextStyle codeSmall = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final TextStyle codeBold = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
}
