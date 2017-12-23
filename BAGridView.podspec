Pod::Spec.new do |s|
    s.name         = 'BAGridView'
    s.version      = '1.0.7'
    s.summary      = '支付宝首页 九宫格 布局封装，可以自定义多种样式，自定义分割线显示/隐藏、颜色等功能应有尽有！'
    s.homepage     = 'https://github.com/BAHome/BAGridView'
    s.license      = 'MIT'
    s.authors      = { 'boai' => 'sunboyan@outlook.com' }
    s.platform     = :ios, '8.0'
    s.source       = { :git => 'https://github.com/BAHome/BAGridView.git', :tag => s.version.to_s }
    s.source_files = 'BAGridView/BAGridView/*.{h,m}'
    s.requires_arc = true
    s.dependency     "SDWebImage"

end
