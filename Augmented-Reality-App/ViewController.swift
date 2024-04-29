//
//  ViewController.swift
//  Augmented-Reality-App
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    var markerData = Marker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        for groupName in AssetDataGroup.allCases {
            if let imageGroup = ARReferenceImage.referenceImages(inGroupNamed: groupName.description, bundle: nil) {
                configuration.trackingImages.formUnion(imageGroup)
            }
        }
    
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // ARImageAnchor에 SCNNode 생성
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.blue
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        return node
    }
    
    // json 데이터 로드
    func loadData() {
            guard let url = Bundle.main.url(forResource: "Marker", withExtension: "json") else {
                fatalError("Unable to find JSON on Bundle")
            }
            guard let data = try? Data(contentsOf: url) else {
                fatalError("Unable to load JSON")
            }
            let decoder = JSONDecoder()
            
            guard let loadedMarkerData = try? decoder.decode([String: AssetsData].self, from: data) else {
                fatalError("Unable to parse JSON")
        }
        markerData = loadedMarkerData
    }
}
