import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    
    @StateObject private var viewModel = ImageViewModel()
    
    init(url: URL?, contentMode: ContentMode = .fill) {
        self.url = url
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
        }
        .onAppear {
            viewModel.loadImage(from: url)
        }
    }
}
