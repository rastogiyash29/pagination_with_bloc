class NetworkInfo{
  final NetworkStatus networkStatus;
  NetworkInfo({required this.networkStatus});
}

enum NetworkStatus{disconnected,connected}