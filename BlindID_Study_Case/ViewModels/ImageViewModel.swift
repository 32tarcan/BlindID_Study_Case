import SwiftUI

@MainActor
class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    private final class Cache {
        static let shared = NSCache<NSString, UIImage>()
        private init() {}
    }
    
    func loadImage(from url: URL?) {
        guard let url = url else { return }
        
        // Check cache first
        if let cached = Cache.shared.object(forKey: url.absoluteString as NSString) {
            self.image = cached
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            
            if let data = data, let uiImage = UIImage(data: data) {
                Cache.shared.setObject(uiImage, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }.resume()
    }
} 
