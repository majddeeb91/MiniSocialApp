class FireStoreResponse {}

class FireStoreException extends FireStoreResponse {
  String message;
  FireStoreException(this.message);
}

class FireStoreResponseData extends FireStoreResponse {
  dynamic responseDataModel;
  FireStoreResponseData(this.responseDataModel);
}
