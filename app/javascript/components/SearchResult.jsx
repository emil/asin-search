import React from 'react';

export default ({ result }) => (
  <a className="item" href={`/products/${result.id}`}>
    <div className="middle aligned content">
      <div className="header">{result.title}</div>
      <div className="meta">{result.asin}</div>
    </div>
  </a>
);
