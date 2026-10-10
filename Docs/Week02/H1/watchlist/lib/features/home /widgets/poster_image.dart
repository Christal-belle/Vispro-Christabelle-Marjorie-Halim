import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  final String? path;
  final Alignment alignment;

  const PosterImage({
    super.key, 
    this.path,
    this.alignment = Alignment.center,
    });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fallback = Container(
      color: scheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.movie_outlined, size: 40)),
    );

    if (path == null || path!.isEmpty) return fallback;

    if (path!.startsWith('http')) {
      return Image.network(
        path!,
        fit: BoxFit.cover,
        alignment: alignment,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : Container(
                color: scheme.surfaceContainerHighest,
                child: const Center(child: CircularProgressIndicator()),
              ),
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return Image.asset(
      path!,
      fit: BoxFit.cover,
      alignment: alignment,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}