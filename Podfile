platform :ios, '17.0'
use_frameworks!

def all_pods
  pod 'SDWebImageSwiftUI'
  pod 'SDWebImageWebPCoder'
  pod 'SDWebImageSVGCoder'
  pod 'SDWebImagePDFCoder'
  pod 'SDWebImageAVIFCoder'
  pod 'libavif', :subspecs => ['libdav1d']
end

target 'bini-pet' do
  platform :ios, '14.0'
  all_pods
end

target 'bini-pet Watch App' do
  platform :watchos, '7.0'
  all_pods
end
