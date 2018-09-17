//
//  VSScanner.swift
//  Scanner
//
//  Created by Scrupulous on 16/9/18.
//  Copyright © 2018 Md. Mamun-Ur-Rashid. All rights reserved.
//


import UIKit
import AVFoundation

class VSScanner: VSXibView {

    var delegate : VSScannerDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var overlayView: UIView?
   
    func viewDidAppear() {
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        self.captureSession = AVCaptureSession()

        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addInput(input)
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            self.setupLiveView()
           
        }
        catch let error  {
            print("Error Unable to initialize scanner:  \(error.localizedDescription)")
        }
    }
    
    func setupLiveView() {
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer.frame = self.bounds
        self.layer.addSublayer(self.previewLayer)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.startScanProcess()
        }
        
        self.overlayView = UIView()
        
        if let qrCodeFrameView = self.overlayView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            self.addSubview(self.overlayView!)
            self.bringSubview(toFront: self.overlayView!)
        }
        
    }
    
    func viewWillDisappear() {
        self.stopScanProcess()
    }
    
    // MARK:- Scan Management
    
    func startScanProcess() {
        self.captureSession.startRunning()
    }
    func stopScanProcess() {
        self.captureSession.stopRunning()
    }
    

}


extension VSScanner : AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            self.overlayView?.frame = CGRect.zero
            self.delegate?.didScan(readableObject: "No Scanning object Detected")
        } else {
            let readableObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            let transformedObject =  self.previewLayer.transformedMetadataObject(for: readableObject)
            self.overlayView?.frame = (transformedObject?.bounds)!
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.delegate?.didScan(readableObject: readableObject.stringValue)
                self.overlayView?.frame = CGRect.zero
            })
        }
        self.captureSession.stopRunning()
    
    }
 
}
