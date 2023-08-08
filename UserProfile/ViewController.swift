//
//  ViewController.swift
//  UserProfile
//
//  Created by danielmateos14 on 31/07/23.
//

import UIKit

class ViewController: UIViewController {

//    let arrayImages: [UIImage] = [UIImage(named: "c++") ?? UIImage(named: "not")!,
//                                  UIImage(named: "java") ?? UIImage(named: "not")!,
//                                  UIImage(named: "c#") ?? UIImage(named: "not")!,
//                                  UIImage(named: "kot") ?? UIImage(named: "not")!,
//                                  UIImage(named: "py") ?? UIImage(named: "not")!,
//                                  UIImage(named: "dart") ?? UIImage(named: "not")!,
//                                  UIImage(named: "php") ?? UIImage(named: "not")!,
//                                  UIImage(named: "js") ?? UIImage(named: "not")!,
//                                  UIImage(named: "sca") ?? UIImage(named: "not")!,
//                                  UIImage(named: "obc") ?? UIImage(named: "not")!]
    var arrayImages: [Any]? = ["","","",""] //array vacio de tipo any para recibir las imagenes del modelo
    var arrayImagesParseadas: [UIImage] = [] //array de tipo imagen para parsear las imagenes
    var objetoPokemones: PokemonModel?
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var buttonRefreshOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let numeroAleatorioEntero: Int = generarNumeroAleatorio()
        let numeroAleatorioDouble: Double = generarNumeroAleatorio()
        print("Prueba funcion numero aleatorio Double con tipo T -> \(numeroAleatorioDouble)")
        PokemonController.shared.requestPokemon(recibeGenerico: numeroAleatorioEntero, actualizarUI: { pokemones in
            self.actualizarUI(recibeObjeto: pokemones)
        })
        self.´init´()
    }
    
    @IBAction func buttonRefresh(_ sender: Any) {
        buttonRefreshOutlet.isEnabled = false
        activityIndicator.startAnimating()
        arrayImagesParseadas.removeAll()
        collectionViewImages.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let numeroAleatorioEntero: Int = self.generarNumeroAleatorio()
            PokemonController.shared.requestPokemon(recibeGenerico: numeroAleatorioEntero, actualizarUI: { pokemones in
                self.actualizarUI(recibeObjeto: pokemones)
            })
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.buttonRefreshOutlet.isEnabled = true
            }
        }
    }
    

    func ´init´ (){
        
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewImages.register(UINib(nibName: "UserProfileCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        ivProfile.layer.cornerRadius = 40
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 110, height: 110) // Tamaño de cada celda
        
        flowLayout.minimumInteritemSpacing = 0 // Espacio mínimo entre celdas (horizontal)
        flowLayout.minimumLineSpacing = 10 // Espacio mínimo entre celdas (vertical)
        // Asignar el UICollectionViewFlowLayout a la colección
        collectionViewImages.collectionViewLayout = flowLayout
    }
    
    func generarNumeroAleatorio<T: Numeric>() -> T{
        let randomInt = Int.random(in: 1..<30)
        let stringRandom = String(randomInt)
        return T(exactly: randomInt)!
    }
    
    func pintarDatos() {
        self.labelStatus.text = "Nombre Pokemon: \(self.objetoPokemones?.name ?? "")"
        labelDescription.text = objetoPokemones?.species?.url
        
        for posicionArray in arrayImages! {
            
            guard let url = URL(string: posicionArray as? String ?? "") else {
                fatalError("Error al crear la url")
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error al descargar la imagen: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Error al convertir los datos en imagen.")
                    return
                }
//                print(posicionArray)
                self.arrayImagesParseadas.append(image)
                DispatchQueue.main.async {
                    self.ivProfile.image = self.arrayImagesParseadas.first
                    self.collectionViewImages.reloadData()
                }
            }.resume()
        }
    }
    
    func actualizarUI(recibeObjeto: PokemonModel){
        self.objetoPokemones = recibeObjeto
        self.arrayImages?[0] = self.objetoPokemones?.sprites?.frontDefault ?? ""
        self.arrayImages?[1] = self.objetoPokemones?.sprites?.backDefault ?? ""
        self.arrayImages?[2] = self.objetoPokemones?.sprites?.frontShiny ?? ""
        self.arrayImages?[3] = self.objetoPokemones?.sprites?.backShiny ?? ""
        DispatchQueue.main.async{
            self.pintarDatos()
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayImagesParseadas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserProfileCellCollectionViewCell else {return UICollectionViewCell()}
        print(arrayImagesParseadas[indexPath.row])
        cell.ivCell.image = arrayImagesParseadas[indexPath.row]
        return cell
    }
    
}


