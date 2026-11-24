import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final double height;       // 👈 Nuevo: permite controlar la altura
  final double? width;       // 👈 Nuevo: permite controlar el ancho (null = ocupa todo el ancho)
  final double iconSize;     // 👈 Nuevo: permite ajustar el tamaño del icono

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.height = 42,        // 👈 Reducimos el alto por defecto de 50 a 42 para que sea más compacto
    this.width,
    this.iconSize = 20,      // 👈 Tamaño equilibrado para el icono
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.indigo.shade900,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: isLoading
            ? SizedBox(
                height: height * 0.5,
                width: height * 0.5,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: width == null ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: height < 40 ? 13 : 14, // Escala el texto si es muy compacto
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}