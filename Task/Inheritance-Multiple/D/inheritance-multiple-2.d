interface Camera {
    // A virtual function.
    Image takePhoto();

    // A non-virtual function.
    final Image[] takeSeveralPhotos(int count) {
        auto result = new Image[count];
        foreach (ref img; result) {
            img = takePhoto();
        }
    }
}
