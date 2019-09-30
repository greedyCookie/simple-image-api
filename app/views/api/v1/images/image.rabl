object @image => false

attributes :height, :width, :id
node(:image_url) {|image| image.content.processed.url}


