package = 'cbloom'
version = 'scm-1'
source  = {
    url    = 'git+https://github.com/creadone/cbloom.git',
    branch = 'master',
}
dependencies = {
    'lua >= 5.1',
    'http >= 1.3.0'
}
build = {
    type = 'builtin',
    modules = {
        ['cbloom'] = 'lua/cbloom.lua',
    }
}