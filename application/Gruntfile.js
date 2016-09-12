module.exports = function (grunt) {

    grunt.initConfig({
        main: {
            files: {
                js: 'src/js/main.js',
                css: 'src/css/main.css',
                html: 'src/html/index.html'
            }
        },
        jshint: {
            files: ['Gruntfile.js', '<%= main.files.js %>'],
            options: {
                globals: {
                    jQuery: true
                }
            }
        },
        uglify: {
            min: {
                files: grunt.file.expandMapping([
                        'src/js/*.js'
                    ],
                    'min/js/',
                    {
                        rename: function (src, dest) {
                            var filename = src + dest.replace('.js', '.min.js');
                            filename = filename.replace('src/js/', '');
                            return filename;
                        }
                    }
                )
            }
        },
        cssmin: {
            min: {
                files: {
                    'min/css/main.min.css': ['<%= main.files.css %>'],
                    'min/css/reset.min.css': 'src/css/reset.css'
                }
            }
        },
        htmlmin: {
            min: {
                options: {
                    removeComments: true,
                    collapseWhitespace: true
                },
                files: {
                    'index.html': '<%= main.files.html %>'
                }
            }
        },
        imagemin: {
            dist: {
                options: {
                    optimizationLevel: 5
                },
                files: [{
                    expand: true,
                    cwd: 'src/images',
                    src: ['**/*.{png,jpg,gif,ico}'],
                    dest: 'min/images'
                }]
            }
        },
        watch: {
            files: ['Gruntfile.js', '<%= main.files.js %>', '<%= main.files.css %>', '<%= main.files.html %>'],
            tasks: ['jshint', 'uglify', 'cssmin', 'htmlmin:min']
        }
    });

    // Load tasks
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-imagemin');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Register tasks
    grunt.registerTask('default', ['jshint', 'uglify', 'cssmin', 'htmlmin:min', 'watch']);

};
