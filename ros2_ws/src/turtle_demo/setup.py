import os
from glob import glob

from setuptools import setup

package_name = 'turtle_demo'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        (os.path.join('share', package_name, 'launch'), glob(os.path.join('launch', '*.launch.py'))),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Automatons',
    maintainer_email='automatons@not.there',
    description='tf2 demo package created using official ROS tutorials for ME396P lightning talk',
    license='Apache License 2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'static_turtle_tf2_broadcaster = turtle_demo.static_turtle_tf2_broadcaster:main',
            'turtle_tf2_broadcaster = turtle_demo.turtle_tf2_broadcaster:main',
            'turtle_tf2_listener = turtle_demo.turtle_tf2_listener:main',
            'fixed_frame_tf2_broadcaster = turtle_demo.fixed_frame_tf2_broadcaster:main',
            'dynamic_frame_tf2_broadcaster = turtle_demo.dynamic_frame_tf2_broadcaster:main',
            'turtle_tf2_listener_travel_in_time = turtle_demo.turtle_tf2_listener_travel_in_time:main',
        ],
    },
)
