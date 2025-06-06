<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" />
  <xsl:template match="/">
    <html>
      <head>
        <link
          rel="stylesheet"
          href="https://static.thisismatter.com/dmarc-xslt/dmarc.css"
        />
      </head>
      <body>
        <xsl:apply-templates />
        <script>
        (function(){
            var parseDate = function(elementId) {
                var dateElement = document.getElementById(elementId)
                var date = new Date(parseInt(dateElement.innerHTML) * 1000)
                dateElement.innerHTML = date.toISOString().replace(/(.+)T(.+)\.[0-9]{3}Z/g, '$1 $2')
            }
            parseDate('date_range-begin')
            parseDate('date_range-end')
        })()
        </script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="feedback">
    <h1>DMARC Report</h1>

    <h2>Report metadata</h2>
    <table border="1">
      <tr>
        <th>Organization</th>
        <th>Email</th>
        <th>Contact info</th>
        <th>Report ID</th>
        <th>Range</th>
      </tr>

      <tr>
        <td>
          <xsl:value-of select="report_metadata/org_name" />
        </td>

        <td>
          <xsl:value-of select="report_metadata/email" />
        </td>
        <td>
          <xsl:value-of select="report_metadata/extra_contact_info" />
        </td>
        <td>
          <xsl:value-of select="report_metadata/report_id" />
        </td>
        <td>
          <span id="date_range-begin"><xsl:value-of select="report_metadata/date_range/begin" /></span>
          -
          <span id="date_range-end"><xsl:value-of select="report_metadata/date_range/end" /></span>
        </td>
      </tr>
    </table>

    <h2>Policy</h2>
    <table border="1">
      <tr>
        <th>Domain</th>
        <th>DKIM Alignment</th>
        <th>SPF Alignment</th>
        <th>Domain policy</th>
        <th>Subdomain policy</th>
        <th>Percentage</th>
      </tr>

      <tr>
        <td>
          <xsl:value-of select="policy_published/domain" />
        </td>

        <td>
          <xsl:value-of select="policy_published/adkim" />
        </td>
        <td>
          <xsl:value-of select="policy_published/aspf" />
        </td>
        <td>
          <xsl:value-of select="policy_published/p" />
        </td>
        <td>
          <xsl:value-of select="policy_published/sp" />
        </td>
        <td>
          <xsl:value-of select="policy_published/pct" />
        </td>
      </tr>
    </table>

    <h2>Records</h2>
    <table border="1">
      <tr>
        <th>Source IP</th>
        <th>Count</th>
        <th>Disposition</th>
        <th>DKIM</th>
        <th>SPF</th>
        <th>Header from</th>
        <th>SPF results</th>
        <th>DKIM results</th>
      </tr>
      <xsl:for-each select="record">
        <tr>
          <td>
            <xsl:value-of select="row/source_ip" />
          </td>

          <td>
            <xsl:value-of select="row/count" />
          </td>

          <td>
            <xsl:value-of select="row/policy_evaluated/disposition" />
          </td>


          <td align="center">
            <xsl:choose>
              <xsl:when test="row/policy_evaluated/dkim='pass'">
                ✔
              </xsl:when>
              <xsl:otherwise>
                ❌
              </xsl:otherwise>
            </xsl:choose>
          </td>

          <td align="center">
            <xsl:choose>
              <xsl:when test="row/policy_evaluated/spf='pass'">
                ✔
              </xsl:when>
              <xsl:otherwise>
                ❌
              </xsl:otherwise>
            </xsl:choose>
          </td>

          <td>
            <xsl:value-of select="identifiers/header_from" />
          </td>

          <td align="begin" class="auth-result">
            <xsl:for-each select="auth_results/spf">
              <div>
                <xsl:choose>
                  <xsl:when test="result='pass'">
                    ✔
                  </xsl:when>
                  <xsl:otherwise>
                    ❌
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:value-of select="domain" />
              </div>
            </xsl:for-each>
          </td>

          <td class="auth-result">
            <xsl:for-each select="auth_results/dkim">
              <div>
                <xsl:choose>
                  <xsl:when test="result='pass'">
                    ✔
                  </xsl:when>
                  <xsl:otherwise>
                    ❌
                  </xsl:otherwise>
                </xsl:choose>

                <!-- $selector.$domain -->
                <xsl:if test="selector">
                  <xsl:value-of select="concat(selector, '.')" />
                </xsl:if>
                <xsl:value-of select="domain" />
              </div>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
</xsl:stylesheet>
