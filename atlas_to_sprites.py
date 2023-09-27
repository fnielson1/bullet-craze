import json
from PIL import Image
import sys
import os

# Access the command-line arguments
script_name = sys.argv[0]
json_file = sys.argv[1]
png_file = json_file.replace('.json', '') + '.png'
save_path = os.path.dirname(png_file) + '/' + 'atlas_to_sprites'


def load_json(filename):
    with open(filename, 'r') as file:
        return json.load(file)

def extract_sprites(atlas_data, atlas_image):
    sprites = {}
    frames = atlas_data['frames']

    for frame_info in frames:
        filename = frame_info['filename']
        separator = '-'
        safe_filename = filename.replace('\\', '/').replace('/', separator)
        
        frame = frame_info['frame']
        x, y, width, height = frame['x'], frame['y'], frame['w'], frame['h'];
        
        sprite_image = atlas_image.crop((x, y, x + width, y + height))
        sprites[safe_filename] = sprite_image
    return sprites


def write_sprites(sprites_dict):
    if not os.path.exists(save_path):
        os.makedirs(save_path)

    print('Saving to: ' + save_path)
    for sprite_name, sprite_png in sprites_dict.items():
        sprite_png.save(save_path + '/' + sprite_name + '.png', format='PNG')



# Load atlas.json file
atlas_data = load_json(json_file)

# Load the atlas PNG image
atlas_image = Image.open(png_file)

# Extract sprites from the atlas PNG
sprites = extract_sprites(atlas_data, atlas_image)

# Now, 'sprites' is a dictionary where keys are sprite names and values are PIL Image objects representing each sprite.
# You can save these images or use them in your application as needed.
write_sprites(sprites)
