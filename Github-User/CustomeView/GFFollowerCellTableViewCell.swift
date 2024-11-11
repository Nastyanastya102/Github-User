import UIKit

class GFFollowerCellTableViewCell: UITableViewCell {
    static let identifier: String = "GFFollowerCellTableViewCell"
    var dataTask: URLSessionDataTask?
    let customImageView = UIImageView()
    let customLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: String, text: String) {
        customLabel.text = text
        
        dataTask?.cancel()  // Cancel any previous task
        
        guard let imageURL = URL(string: image) else {
            customImageView.image = UIImage(systemName: "photo")  // Placeholder image
            return
        }
        
        // Fetch image from URL
        dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self.customImageView.image = UIImage(data: data)
            }
        }
        dataTask?.resume()
    }
    
    private func setupSubviews() {
        contentView.addSubview(customImageView)
        contentView.addSubview(customLabel)
        
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
        customLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        customLabel.textColor = .black
    }

    private func setupConstraints() {
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customImageView.widthAnchor.constraint(equalToConstant: 40),
            customImageView.heightAnchor.constraint(equalToConstant: 40),
            
            customLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 15),
            customLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
