import React from 'react';
import axios from 'axios';

export default class Search extends React.Component {
  state = { loading: false, results: [] };

  render() {
    const { loading, results } = this.state;
    return (
      <div className="ui raised segment no padding">
        <form method="GET" action="search">
          <div className="ui fluid icon transparent large input">
            <input name="query" type="text" placeholder="Search (ASIN, title...)" autoComplete="off" />
            <button type="submit">
              <i className="search icon"></i>
            </button>
          </div>
        </form>
      </div>
    );
  }
}
