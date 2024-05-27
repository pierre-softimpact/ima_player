part of 'ima_player.dart';

class _ImaPlayerView extends StatefulWidget {
  const _ImaPlayerView(
    this.creationParams, {
    required this.gestureRecognizers,
    required this.onViewCreated,
  });

  final Map<String, dynamic> creationParams;
  final void Function(int viewId) onViewCreated;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State<_ImaPlayerView> createState() => _ImaPlayerViewState();
}

class _ImaPlayerViewState extends State<_ImaPlayerView> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    const viewType = 'gece.dev/imaplayer_view';

    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers:  const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: widget.creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(widget.onViewCreated)
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        creationParams: widget.creationParams,
        gestureRecognizers: widget.gestureRecognizers,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: widget.onViewCreated,
      );
    }
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
