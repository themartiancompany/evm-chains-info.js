/**    ----------------------------------------------------------------
 *     webpack.config.cjs
 *     ----------------------------------------------------------------
 *     Copyright ©
 *       Pellegrino Prevete
 *         2024, 2025, 2026
 * 
 *     All rights reserved
 *     ----------------------------------------------------------------
 * 
 *     This program is free software: you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License as
 *     published by the Free Software Foundation, either version 3 of
 *     the License, or (at your option) any later version.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with this program.
 *     If not, see <https://www.gnu.org/licenses/>.
 */

const
  _path =
    require(
      'path');
const
  _output_dir =
    _path.resolve(
      __dirname);
const
  _input_file_name =
    `evm-chains-info`;
const
  _input_file_path =
    `./${_input_file_name}`;
const
  _output_file_name =
    `${_input_file_name}.js`;
const
  _output = {
    path:
      _output_dir,
    filename:
      _output_file_name
};
const
  _utils_ignore =
  { resourceRegExp:
      /^utils$/ };
const
  _web_worker_ignore =
  { resourceRegExp:
      /^web-worker$/ };
const
  _yargs_ignore =
  { resourceRegExp:
      /^yargs$/ };
const
  _yargs_helpers_ignore =
  { resourceRegExp:
      /^yargs\/helpers$/ };
const
  _webpack =
    require(
     "webpack");
const
  _ignore_plugin =
    _webpack.IgnorePlugin; 
const
  _utils_ignore_plugin =
    new _ignore_plugin(
          _utils_ignore);
const
  _web_worker_ignore_plugin =
    new _ignore_plugin(
          _web_worker_ignore);
const
  _yargs_ignore_plugin =
    new _ignore_plugin(
          _yargs_ignore);
const
  _yargs_helpers_ignore_plugin =
    new _ignore_plugin(
          _yargs_helpers_ignore);
module.exports = {
  entry:
    _input_file_path,
  output:
    _output,
  optimization: {
    moduleIds: 'deterministic',
  },
  resolve: {
    alias: {
      "evm-contracts-tools":
        _path.resolve(
          __dirname,
          'node_modules/evm-contract-tools/evm-contracts-tools'),
      "evm-wallet.js":
        _path.resolve(
          __dirname,
          'node_modules/evm-wallet.js/libevm-wallet'),
      "fs":
        _path.resolve(
          __dirname,
          'node_modules/fs/fs'),
      "path":
        _path.resolve(
          __dirname,
          'node_modules/path/mod.js'),
      "web-worker":
        _path.resolve(
          __dirname,
          'node_modules/web-worker/mod.js'),
      "yargs":
        _path.resolve(
          __dirname,
          'node_modules/yargs/browser.mjs'),
      "yargs/helpers":
        _path.resolve(
          __dirname,
          'node_modules/yargs/helpers/helpers.mjs'),
      "yargs-parser":
        _path.resolve(
          __dirname,
          'node_modules/yargs-parser/browser.mjs'),
    },
    fallback: {
      "utils":
        false,
      "web-worker":
        false,
      "yargs":
        false,
      "yargs/helpers":
        false,
    }
  },
  externals:
    { yargs:
        'yargs' },
  plugins: [
    _yargs_ignore_plugin,
    _yargs_helpers_ignore_plugin
  ]
};
