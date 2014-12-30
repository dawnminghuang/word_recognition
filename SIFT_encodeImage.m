% 输入的是encoder:代表利用SIFT生成bovw。im:需要提取SIFT特征的图片名字。cache：得到的特征存放的路径。
% example：
%encoding = 'bovw' ;
%encoder = load(sprintf('encoder_%s.mat',encoding));
%pos.names =read_image(root,out_i,ni) ;
%pos.histograms =SIFT_encodeImage(encoder, pos.names, ['pos_' encoding]) ;
function psi = SIFT_encodeImage(encoder, im, cache)
% COMPUTEENCODING   Compute a spatial encoding of visual words
%   PSI = ENCODEIMAGE(ENCODER, IM) applies the specified ENCODER
%   to image IM, reurning a corresponding code vector PSI.
%
%   IM can be an image, the path to an image, or a cell array of
%   the same, to operate on multiple images.
%
%   ENCODEIMAGE(ENCODER, IM, CACHE) utilizes the specified CACHE
%   directory to store encodings for the given images. The cache
%   is used only if the images are specified as file names.

% Author: Andrea Vedaldi

if ~iscell(im), im = {im} ; end
if nargin <= 2, cache = [] ; end

psi = cell(1,numel(im)) ;
if numel(im) > 1
  parfor i = 1:numel(im)
    psi{i} = processOne(encoder, im{i}, cache) ;
  end
elseif numel(im) == 1
  psi{1} = processOne(encoder, im{1}, cache) ;
end
psi = cat(2, psi{:}) ;

% --------------------------------------------------------------------
function psi = processOne(encoder, im, cache)
% --------------------------------------------------------------------
if isstr(im)
  if ~isempty(cache)
    psi = getFromCache(im, cache) ;%已经在cache里存在的就直接存取
    if ~isempty(psi), return ; end
  end
  fprintf('encoding image %s\n', im) ;
end

psi = encodeOne(encoder, im) ;

if isstr(im) & ~isempty(cache)
  storeToCache(im, cache, psi) ;
end

% --------------------------------------------------------------------
function psi = encodeOne(encoder, im)
% --------------------------------------------------------------------

im = standardizeImage(im) ;

[keypoints, descriptors] = computeFeatures(im) ;

imageSize = size(im) ;
psi = {} ;
for i = 1:size(encoder.subdivisions,2)
  minx = encoder.subdivisions(1,i) * imageSize(2) ;
  miny = encoder.subdivisions(2,i) * imageSize(1) ;
  maxx = encoder.subdivisions(3,i) * imageSize(2) ;
  maxy = encoder.subdivisions(4,i) * imageSize(1) ;

  ok = ...
    minx <= keypoints(1,:) & keypoints(1,:) < maxx  & ...
    miny <= keypoints(2,:) & keypoints(2,:) < maxy ;

  % Note: while one must remove the mean from the descriptor to
  % compute the PCA projection, the mean is irrelevant for the
  % encoding and therefore it is not subtracted here.

  switch encoder.type
    case 'bovw'
      [words,distances] = vl_kdtreequery(encoder.kdtree, encoder.words, ...
                                         encoder.projection * descriptors(:,ok), ...
                                         'MaxComparisons', 15) ;
      z = vl_binsum(zeros(encoder.numWords,1), 1, double(words)) ;

    case 'fv'
      z = vl_fisher(encoder.projection * descriptors(:,ok), ...
                    encoder.means, ...
                    encoder.covariances, ...
                    encoder.priors) ;
    case 'vlad'
      [words,distances] = vl_kdtreequery(encoder.kdtree, encoder.words, ...
                                         encoder.projection * descriptors(:,ok), ...
                                         'MaxComparisons', 15) ;
      assign = zeros(encoder.numWords, numel(words), 'single') ;
      assign(sub2ind(size(assign), double(words), 1:numel(words))) = 1 ;
      z = vl_vlad(encoder.projection * descriptors(:,ok), ...
                  encoder.words, ...
                  assign, 'normalizecomponents') ;
                   z = vl_vlad(encoder.projection * descriptors(:,ok), ...
                  encoder.words, ...
                  assign) ;
  end
  psi{i} = z(:) ;
end
psi = cat(1, psi{:}) ;

% --------------------------------------------------------------------
function psi = getFromCache(name, cache)
% --------------------------------------------------------------------
[drop, name] = fileparts(name) ;
cachePath = fullfile(cache, [name '.mat']) ;
if exist(cachePath, 'file')
  data = load(cachePath) ;
  psi = data.psi ;
else
  psi = [] ;
end

% --------------------------------------------------------------------
function storeToCache(name, cache, psi)
% --------------------------------------------------------------------
[drop, name] = fileparts(name) ;
cachePath = fullfile(cache, [name '.mat']) ;
vl_xmkdir(cache) ;
data.psi = psi ;
save(cachePath, '-STRUCT', 'data') ;
function im = standardizeImage(im)
% STANDARDIZEIMAGE  Rescale an image to a standard size
%   IM = STANDARDIZEIMAGE(IM) rescale IM to have a height of at most
%   480 pixels.

% Author: Andrea Vedaldi

if isstr(im)
  if exist(im, 'file')
    fullPath = im ;
  else
    fullPath = fullfile('data','images',[im '.jpg']) ;
  end
  im =imread(fullPath) ;
%    im=single(imresize(im,[128,128]));
end

im = im2single(im) ;
if size(im,1) > 480, im = imresize(im, [480 NaN]) ; end
function [keypoints,descriptors] = computeFeatures(im)
% COMPUTEFEATURES Compute keypoints and descriptors for an image
%   [KEYPOINTS, DESCRIPTORS] = COMPUTEFEAUTRES(IM) computes the
%   keypoints and descriptors from the image IM. KEYPOINTS is a 4 x K
%   matrix with one column for keypoint, specifying the X,Y location,
%   the SCALE, and the CONTRAST of the keypoint.
%
%   DESCRIPTORS is a 128 x K matrix of SIFT descriptors of the
%   keypoints.

% Author: Andrea Vedaldi

im = standardizeImage(im) ;
[keypoints, descriptors] = vl_phow(im, 'step', 4, 'floatdescriptors', true) ;
