package = 'cbloom'
version = 'scm-1'
source  = {
    url    = 'git+https://github.com/creadone/cbloom.git',
    branch = 'master',
}
dependencies = {
    'lua >= 5.1',
}
build = {
    type = 'builtin',
    modules = {
        ['cbloom'] = 'lua/cbloom.lua',
    }
}