//
//  PhotoCaptureView.swift
//  PhotoCaptureView
//
//  Created by Andy Cho on 3/9/22.
//  Copyright © 2022 Andy Cho. All rights reserved.
//

/*
 * Picker struct to either pick between to take a photo or 
 */

import SwiftUI

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var photoImageData: Data?
    
    let cameraOrLibrary: String
    
    var body: some View {
        
        ImagePicker(imagePickerShown: $showImagePicker,
                    photoImageData: $photoImageData,
                    cameraOrLibrary: cameraOrLibrary)
    }
}

