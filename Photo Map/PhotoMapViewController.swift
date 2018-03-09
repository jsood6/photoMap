//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, LocationsViewControllerDelegate  {
    

    var capturedImage: UIImage!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        //vc.sourceType = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        capturedImage = originalImage
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        picker.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        self.navigationController?.popToViewController(self, animated: true)
        let lat = latitude as! Double
        let long = longitude as! Double
        let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude:long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "\(latitude)"
        mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }

        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")

        return annotationView
    }
    
//    @objc func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        let reuseID = "myAnnotationView"
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
//        if (annotationView == nil) {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
//            annotationView!.canShowCallout = true
//            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
//        }
//
//        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
//        imageView.image = UIImage(named: "camera")
//
//        return annotationView
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let locationsVC = segue.destination as! LocationsViewController
        locationsVC.delegate = self
        // Pass the selected object to the new view controller.
        locationsVC.capturedImage = self.capturedImage
    }
    

}
