import {ALL_VIEWS, SPECIAL_FIELDS} from './data';

/**
 * Given a view id, return the corresponding view object
 *
 * @param {String} requestedView
 * @returns {Object}
 *
 */
export function getCurrentView(requestedView) {
  return ALL_VIEWS.find(view => view.id === requestedView) || ALL_VIEWS[0];
}

/**
 * Takes a view and converts it into the format required for the events API
 *
 * @param {Object} view
 * @returns {Object}
 */
export function getQuery(view) {
  const data = {...view.data};
  const fields = data.fields.reduce((list, field) => {
    if (SPECIAL_FIELDS.hasOwnProperty(field)) {
      list.push(...SPECIAL_FIELDS[field].fields);
    } else {
      list.push(field);
    }
    return list;
  }, []);

  data.field = [...new Set(fields)];

  return data;
}

/**
 * Fetches tag distributions for heatmaps for an array of tag keys
 *
 * @param {Object} api
 * @param {String} orgSlug
 * @param {Array} tagList
 * @returns {Promise<Object>}
 */
export function fetchTags(api, orgSlug, tagList) {
  return api
    .requestPromise(`/organizations/${orgSlug}/events-heatmap/`, {
      query: {keys: tagList},
    })
    .then(resp => {
      const tags = {};
      resp.forEach(tag => {
        tags[tag.key] = tag;
      });
      return tags;
    });
}
